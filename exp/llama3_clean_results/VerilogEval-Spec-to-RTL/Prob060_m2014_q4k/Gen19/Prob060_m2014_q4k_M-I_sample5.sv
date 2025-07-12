// Wide D Flip-Flop Module with Active-Low Synchronous Reset and Clock Gating
module WideDFF(
    input clk,
    input resetn,
    input clk_en, // Clock enable for clock gating
    input [3:0] d,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (clk_en) begin
        if (!resetn) begin
            q <= 4'b0;
        end else begin
            q <= d;
        end
    end
end

endmodule

// TopModule with Wide D Flip-Flop Shift Register and Clock Gating
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;
reg clk_en; // Clock enable signal

// Generate clock enable signal based on input activity
always @(posedge clk) begin
    if (!resetn) begin
        clk_en <= 1'b0;
    end else if (in != 1'b0) begin // Example condition, adjust based on actual requirements
        clk_en <= 1'b1;
    end else begin
        clk_en <= 1'b0;
    end
end

// Instantiate the wide D flip-flop module with clock gating
WideDFF wide_dff(clk, resetn, clk_en, {q[2:0], in}, q);

// Assign output directly from the last bit of the wide D flip-flop
assign out = q[3];

endmodule