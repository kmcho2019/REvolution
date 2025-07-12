module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] state;
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= S000;
    end else begin
        case (state)
            S000: state <= (x == 1'b0) ? S000 : S001;
            S001: state <= (x == 1'b0) ? S001 : S100;
            S010: state <= (x == 1'b0) ? S010 : S001;
            S011: state <= (x == 1'b0) ? S001 : S010;
            S100: state <= (x == 1'b0) ? S011 : S100;
            default: state <= S000; // default to S000 for invalid states
        endcase
    end
end

always_comb begin
    case (state)
        S000: z = 1'b0;
        S001: z = 1'b0;
        S010: z = 1'b0;
        S011: z = 1'b1;
        S100: z = 1'b1;
        default: z = 1'b0; // default to 0 for invalid states
    endcase
end

endmodule