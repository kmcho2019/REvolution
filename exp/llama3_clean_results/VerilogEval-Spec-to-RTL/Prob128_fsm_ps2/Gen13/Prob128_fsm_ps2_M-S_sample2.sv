module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] count;

always_ff @(posedge clk) begin
    if (reset) begin
        count <= 0;
        done <= 0;
    end else if (in[3]) begin
        // If a byte with in[3]=1 is encountered, set count to 1
        count <= 1;
    end else if (count > 0) begin
        // If count is not zero, increment it
        count <= count + 1;
    end

    // Assert 'done' when count reaches 3
    if (count == 3) begin
        done <= 1;
    end else begin
        done <= 0;
    end
end

endmodule