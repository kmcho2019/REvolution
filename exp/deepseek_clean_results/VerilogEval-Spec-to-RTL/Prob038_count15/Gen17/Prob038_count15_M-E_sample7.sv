module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire feedback;
wire [3:0] next_q;

// Custom feedback logic for binary counting sequence
assign feedback = ~(q[3] ^ q[2] ^ q[1] ^ q[0]);
assign next_q = {q[2:0], feedback};

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        // Special case handling for rollover from 15 to 0
        if (q == 4'b1111) begin
            q <= 4'b0000;
        end
        else begin
            q <= next_q;
        end
    end
end

endmodule