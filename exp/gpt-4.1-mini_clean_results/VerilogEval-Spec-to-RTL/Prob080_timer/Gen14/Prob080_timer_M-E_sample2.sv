module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg active;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            active <= (data != 0);
        end else if (active) begin
            if (counter == 1) begin
                counter <= 0;
                active <= 0;
            end else begin
                counter <= counter - 1;
            end
        end
    end

    assign tc = (counter == 0);

endmodule