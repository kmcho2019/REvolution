module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= (data == 10'd0) ? 1'b1 : 1'b0;  // If loaded zero, tc is asserted immediately
        end else begin
            if (counter != 10'd0) begin
                counter <= counter - 10'd1;
                tc <= 1'b0;
                if (counter == 10'd1)
                    tc <= 1'b1; // Next count will be zero, so assert tc
            end else begin
                // counter is zero, keep tc asserted
                tc <= 1'b1;
            end
        end
    end

endmodule