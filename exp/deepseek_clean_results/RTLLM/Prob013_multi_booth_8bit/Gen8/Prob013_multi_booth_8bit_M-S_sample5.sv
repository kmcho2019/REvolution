module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // 8 bits + 1 extra for Booth
    reg [2:0] ctr;         // 4 steps (0-3) for 8 bits
    reg [1:0] state;

    // States
    localparam IDLE    = 2'b00;
    localparam PROCESS = 2'b01;
    localparam DONE    = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Add LSB=0 for Booth
            p <= 16'b0;
            rdy <= 1'b0;
            ctr <= 3'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // Start multiplication
                    state <= PROCESS;
                    ctr <= 3'b0;
                    rdy <= 1'b0;
                end

                PROCESS: begin
                    // Radix-4 Booth processing
                    case (multiplier[2:0])
                        3'b000, 3'b111: ; // No operation
                        3'b001, 3'b010: p <= p + multiplicand;
                        3'b011:         p <= p + (multiplicand << 1);
                        3'b100:         p <= p - (multiplicand << 1);
                        3'b101, 3'b110: p <= p - multiplicand;
                    endcase

                    // Shift and increment
                    multiplier <= multiplier >>> 2;
                    ctr <= ctr + 1;

                    // Check completion
                    if (ctr == 3'b11) state <= DONE;
                end

                DONE: begin
                    // Finalize operation
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule