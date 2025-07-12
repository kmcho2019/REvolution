module TopModule(
    input clk,
    input a,
    output reg q
);

reg q_prev; // To store the previous state of q

always @(posedge clk) begin
    if (q === 1'bx || q_prev === 1'bx) begin // Initialize q and q_prev on the first clock edge
        q <= 1'b1;
        q_prev <= 1'b1;
    end else begin
        if (a === 1'b0) begin // If a is 0, set q to 1 on the next positive edge
            q <= 1'b1;
        end else if (a === 1'b1) begin // If a is 1, toggle q
            q <= ~q;
        end
        q_prev <= q; // Update q_prev for the next clock cycle
    end
end

endmodule