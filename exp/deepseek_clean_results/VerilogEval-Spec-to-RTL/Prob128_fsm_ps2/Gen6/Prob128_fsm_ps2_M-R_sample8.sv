module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_counter;
    
    assign done = (byte_counter == 2);

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 0;
        end else begin
            byte_counter <= (in[3] || byte_counter != 0) ? 
                           (byte_counter == 2 ? 0 : byte_counter + 1) : 
                           0;
        end
    end

endmodule