module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [2:0] count;
reg state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        count <= 3'b000;
        z <= 0;
    end else begin
        if (state == 0) begin
            if (s == 1) begin
                state <= 1;
                count <= 3'b000;
            end
        end else begin
            // count w = 1 in the last three clock cycles
            count <= {count[1:0], w};
            
            // check if we have checked three clock cycles
            if (count[2] == 1'b1) begin
                // check if w = 1 in exactly two of the last three clock cycles
                if (count == 3'b011 || count == 3'b101 || count == 3'b110) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
            end else begin
                z <= 1'b0;
            end
        end
    end
end

endmodule