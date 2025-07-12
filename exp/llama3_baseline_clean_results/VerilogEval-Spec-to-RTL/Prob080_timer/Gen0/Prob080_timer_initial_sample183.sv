module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count; // internal counter

always @(posedge clk) begin
    if (load) begin
        count <= data; // load new value when load is high
        tc <= 0; // reset terminal count when loading
    end else begin
        if (count > 0) begin
            count <= count - 1; // decrement count when load is low and count is not 0
        end
    end
end

assign tc = (count == 0) ? 1 : 0; // set terminal count high when count is 0

endmodule