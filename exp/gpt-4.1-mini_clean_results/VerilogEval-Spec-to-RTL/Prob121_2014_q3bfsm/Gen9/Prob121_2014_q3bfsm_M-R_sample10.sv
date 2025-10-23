module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    // State encoding as parameters
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    state <= (x) ? S1 : S0;
                    z <= 1'b0;
                end
                S1: begin
                    state <= (x) ? S4 : S1;
                    z <= 1'b0;
                end
                S2: begin
                    state <= (x) ? S1 : S2;
                    z <= 1'b0;
                end
                S3: begin
                    state <= (x) ? S2 : S1;
                    z <= 1'b1;
                end
                S4: begin
                    state <= (x) ? S4 : S3;
                    z <= 1'b1;
                end
                default: begin
                    state <= S0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule