module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] acc; // accumulator to store the input number
reg [31:0] res; // register to store the result
reg [4:0] cnt;  // counter to keep track of the number of bits
reg running;     // flag to indicate whether the FSM is running

always @(posedge clk or posedge areset) begin
    if(areset) begin
        acc <= 0;
        res <= 0;
        cnt <= 0;
        running <= 0;
        z <= 0;
    end else if (~areset && ~running) begin
        running <= 1;
        acc <= 0;
        cnt <= 0;
    end else if (running) begin
        if (cnt == 31) begin // assuming 32-bit numbers
            acc <= acc;
            res <= ~acc + 1; // invert and add one
            cnt <= cnt;
            running <= 0;
        end else begin
            acc <= {acc[30:0], x}; // shift in the new bit
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (~areset && running) begin
        z <= acc[31]; // output the current bit of the result
    end else if (~areset && ~running) begin
        z <= res[31]; // output the 2's complement result bit by bit
        res <= {res[30:0], 1'b0}; // shift out the result
    end else begin
        z <= 0;
    end
end

endmodule