module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] count;
    reg counting_done;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
            counting_done <= 1'b0;
        end else if (!counting_done) begin
            if (count == 2'b11) begin
                counting_done <= 1'b1;
            end else begin
                count <= count + 1;
            end
        end
    end

    assign shift_ena = reset ? 1'b1 : !counting_done;

endmodule