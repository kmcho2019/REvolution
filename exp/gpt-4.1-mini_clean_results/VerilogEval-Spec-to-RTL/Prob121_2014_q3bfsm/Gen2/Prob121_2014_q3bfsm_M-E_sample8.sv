module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;

    // State encoding (binary)
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case(state)
                S0: begin
                    if (x == 1'b0) begin
                        state <= S0;
                        z <= 1'b0;
                    end else begin
                        state <= S1;
                        z <= 1'b0;
                    end
                end
                S1: begin
                    if (x == 1'b0) begin
                        state <= S1;
                        z <= 1'b0;
                    end else begin
                        state <= S4;
                        z <= 1'b1;
                    end
                end
                S2: begin
                    if (x == 1'b0) begin
                        state <= S2;
                        z <= 1'b0;
                    end else begin
                        state <= S1;
                        z <= 1'b0;
                    end
                end
                S3: begin
                    if (x == 1'b0) begin
                        state <= S1;
                        z <= 1'b1;
                    end else begin
                        state <= S2;
                        z <= 1'b0;
                    end
                end
                S4: begin
                    if (x == 1'b0) begin
                        state <= S3;
                        z <= 1'b1;
                    end else begin
                        state <= S4;
                        z <= 1'b1;
                    end
                end
                default: begin
                    state <= S0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule