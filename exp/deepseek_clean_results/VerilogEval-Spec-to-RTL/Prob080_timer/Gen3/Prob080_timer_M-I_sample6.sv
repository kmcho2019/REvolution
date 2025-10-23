module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    wire counter_enable = load || (counter != 0);

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (counter != 0) begin
            counter <= counter - 1;
        end

        // Registered output improves timing
        tc <= (counter == 0);
    end

endmodule