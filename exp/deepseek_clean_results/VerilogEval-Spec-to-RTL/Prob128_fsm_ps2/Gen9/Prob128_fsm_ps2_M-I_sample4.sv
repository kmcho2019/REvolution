module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_counter;

    // Combinational done signal
    assign done = (byte_counter == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'd0;
        end else begin
            if (in[3] || (byte_counter != 2'd0)) begin
                byte_counter <= (byte_counter == 2'd2) ? 2'd0 : byte_counter + 1'b1;
            end
        end
    end

endmodule