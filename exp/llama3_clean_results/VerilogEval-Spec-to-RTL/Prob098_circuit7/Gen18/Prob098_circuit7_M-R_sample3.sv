module TopModule(
    input clk,
    input a,
    output reg q
);

// Initial state
initial q = 1'b1;

// State transition and output logic
always @(posedge clk) begin
    if (a) begin
        q <= 1'b0;
    end else if (!a && q == 1'b0) begin
        q <= 1'b1;
    end
end

endmodule