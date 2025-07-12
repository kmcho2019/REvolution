module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] acc; // accumulate input bits
reg [31:0] result; // store the final result
reg [4:0] count; // count the number of input bits
reg running; // flag to indicate when the machine is running
reg sign; // flag to indicate the sign of the input number

always @(posedge clk or posedge areset) begin
    if (areset) begin
        acc <= 0;
        result <= 0;
        count <= 0;
        running <= 0;
        sign <= 0;
        z <= 0;
    end else if (!running) begin
        running <= 1;
    end else begin
        if (count == 31) begin
            // handle the case when the input number is all ones
            if (x) begin
                result <= {1'b1, 31'b0};
            end else begin
                result <= {1'b0, acc};
            end
            running <= 0;
        end else begin
            acc <= {acc[30:0], x};
            count <= count + 1;
            sign <= x;
        end
    end
end

always @(posedge clk) begin
    if (running) begin
        if (count == 31) begin
            z <= result[31-count];
        end else begin
            z <= 1'b0;
        end
    end else begin
        z <= 1'b0;
    end
end

endmodule