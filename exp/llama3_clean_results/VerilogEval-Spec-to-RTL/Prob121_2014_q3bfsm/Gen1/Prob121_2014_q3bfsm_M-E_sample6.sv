module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

// Define the states
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// State register
reg [2:0] y;

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        y <= S000;
        z <= 1'b0;
    end else begin
        case (y)
            S000: begin
                y <= (x == 1'b0) ? S000 : S001;
                z <= 1'b0;
            end
            S001: begin
                y <= (x == 1'b0) ? S001 : S100;
                z <= 1'b0;
            end
            S010: begin
                y <= (x == 1'b0) ? S010 : S001;
                z <= 1'b0;
            end
            S011: begin
                y <= (x == 1'b0) ? S001 : S010;
                z <= 1'b1;
            end
            S100: begin
                y <= (x == 1'b0) ? S011 : S100;
                z <= 1'b1;
            end
            default: begin
                y <= S000; // default state
                z <= 1'b0; // default output
            end
        endcase
    end
end

endmodule