module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam [2:0] IDLE  = 3'b001;
    localparam [2:0] BYTE2 = 3'b010;
    localparam [2:0] BYTE3 = 3'b100;

    reg [2:0] state;
    reg [23:0] shift_reg;
    reg [1:0] byte_counter;

    // Combinational done signal
    assign done = (state == BYTE3);
    assign out_bytes = shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_counter <= 2'b00;
            shift_reg <= 24'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg[23:16] <= in;
                        byte_counter <= 2'b01;
                        state <= BYTE2;
                    end
                end
                
                BYTE2: begin
                    shift_reg[15:8] <= in;
                    byte_counter <= 2'b10;
                    state <= BYTE3;
                end
                
                BYTE3: begin
                    shift_reg[7:0] <= in;
                    byte_counter <= 2'b00;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule