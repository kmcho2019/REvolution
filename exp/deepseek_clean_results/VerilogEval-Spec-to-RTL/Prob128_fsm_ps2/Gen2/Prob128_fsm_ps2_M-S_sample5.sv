module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b0;
        end else begin
            if (byte_count == 2'b10) begin
                byte_count <= 2'b0;  // Reset after third byte
            end else if (byte_count != 0 || in[3]) begin
                byte_count <= byte_count + 1'b1;
            end
        end
    end

    assign done = (byte_count == 2'b10);
endmodule