module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states
    reg [2:0] state;
    localparam IDLE   = 3'b001;
    localparam BYTE1  = 3'b010;
    localparam BYTE2  = 3'b100;

    // Separate byte registers for better timing
    reg [7:0] byte0_reg;
    reg [7:0] byte1_reg;
    reg [7:0] byte2_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte0_reg <= 8'b0;
            byte1_reg <= 8'b0;
            byte2_reg <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte0_reg <= in;
                        state <= BYTE1;
                    end
                end

                BYTE1: begin
                    byte1_reg <= in;
                    state <= BYTE2;
                end

                BYTE2: begin
                    byte2_reg <= in;
                    out_bytes <= {byte0_reg, byte1_reg, in};
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule