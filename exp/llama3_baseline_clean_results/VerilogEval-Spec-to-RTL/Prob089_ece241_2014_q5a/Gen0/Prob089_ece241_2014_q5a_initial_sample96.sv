module TopModule (
    input         clk,
    input         areset,
    input         x,
    output        z
);

reg [31:0] num;  // assuming a max of 32 bits for the input number
reg [4:0]  cnt;  // counter to keep track of the input bits
reg        started;  // flag to indicate when the reset is released
reg        inv;     // flag to indicate when to invert the output

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        num <= 32'd0;
        cnt <= 5'd0;
        started <= 1'b0;
        inv <= 1'b0;
        z <= 1'b0;
    end else if (~areset && ~started) begin
        started <= 1'b1;
    end else if (started) begin
        num <= {num[30:0], x};  // shift in the input bit
        cnt <= cnt + 1'b1;      // increment the counter
        if (x) begin
            inv <= 1'b1;        // set the invert flag
        end
    end
end

always @ (posedge areset) begin
    if (areset) begin
        z <= 1'b0;
    end else begin
        if (inv) begin
            z <= ~num[31-cnt+1];  // output the 2's complement
        end else begin
            z <= num[31-cnt+1];   // output the input bit
        end
    end
end

endmodule