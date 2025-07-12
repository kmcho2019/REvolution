module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset)
            counter <= 3'b000;
        else begin
            case (counter)
                3'b000: counter <= x ? counter + 1 : counter;
                3'b001: counter <= x ? counter + 3 : counter;
                3'b010: counter <= x ? counter - 1 : counter;
                3'b011: counter <= x ? counter - 1 : counter - 2;
                3'b100: counter <= x ? counter : counter - 1;
                default: counter <= 3'b000;
            endcase
        end
    end

    // Output logic remains the same as original
    assign z = (counter == 3'b011) || (counter == 3'b100);

endmodule