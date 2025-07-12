module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Pipeline stage registers
    reg [15:0] a_reg, b_reg;
    reg [2:0] booth_sel [0:7];
    reg [31:0] pp [0:7];
    reg [31:0] sum1, carry1;
    reg [31:0] sum2, carry2;
    reg [31:0] final_sum;

    // Control signals
    reg [2:0] state;
    reg [3:0] count;
    reg zero_case;

    localparam IDLE = 3'b000;
    localparam BOOTH = 3'b001;
    localparam PP_GEN = 3'b010;
    localparam REDUCE1 = 3'b011;
    localparam REDUCE2 = 3'b100;
    localparam FINAL = 3'b101;
    localparam DONE_ST = 3'b110;

    // Booth encoding function
    function [2:0] booth_enc;
        input [2:0] b;
        begin
            case (b)
                3'b000: booth_enc = 3'b000; // 0
                3'b001: booth_enc = 3'b001; // +1
                3'b010: booth_enc = 3'b001; // +1
                3'b011: booth_enc = 3'b010; // +2
                3'b100: booth_enc = 3'b110; // -2
                3'b101: booth_enc = 3'b101; // -1
                3'b110: booth_enc = 3'b101; // -1
                3'b111: booth_enc = 3'b000; // 0
            endcase
        end
    endfunction

    // Main state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            done <= 0;
            yout <= 0;
            zero_case <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        a_reg <= ain;
                        b_reg <= bin;
                        zero_case <= (bin == 0);
                        state <= zero_case ? FINAL : BOOTH;
                    end
                end
                
                BOOTH: begin
                    // Generate 8 booth digits
                    booth_sel[0] <= booth_enc({b_reg[1:0], 1'b0});
                    for (integer i = 1; i < 8; i = i + 1)
                        booth_sel[i] <= booth_enc(b_reg[2*i+1:2*i-1]);
                    state <= PP_GEN;
                end
                
                PP_GEN: begin
                    // Generate partial products
                    for (integer i = 0; i < 8; i = i + 1) begin
                        case (booth_sel[i])
                            3'b001: pp[i] <= {16'b0, a_reg} << (2*i);
                            3'b010: pp[i] <= {15'b0, a_reg, 1'b0} << (2*i);
                            3'b101: pp[i] <= ~({16'b0, a_reg} << (2*i)) + 1;
                            3'b110: pp[i] <= ~({15'b0, a_reg, 1'b0} << (2*i)) + 1;
                            default: pp[i] <= 0;
                        endcase
                    end
                    state <= REDUCE1;
                end
                
                REDUCE1: begin
                    // First level of 3:2 compressors
                    {sum1, carry1} <= pp[0] + pp[1] + pp[2];
                    state <= REDUCE2;
                end
                
                REDUCE2: begin
                    // Second level of reduction
                    {sum2, carry2} <= sum1 + carry1 + pp[3] + pp[4] + pp[5];
                    state <= FINAL;
                end
                
                FINAL: begin
                    // Final addition
                    final_sum <= sum2 + carry2 + pp[6] + pp[7];
                    yout <= zero_case ? 0 : final_sum;
                    done <= 1;
                    state <= DONE_ST;
                end
                
                DONE_ST: begin
                    done <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule