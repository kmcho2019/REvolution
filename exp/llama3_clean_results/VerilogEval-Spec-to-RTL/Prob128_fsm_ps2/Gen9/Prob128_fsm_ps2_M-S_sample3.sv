module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] counter;

always_ff @(posedge clk) begin
    if(reset) begin
        counter <= 0;
        done <= 0;
    end else begin
        if (in[3] && counter == 0) begin
            counter <= 1;
        end else if (counter > 0 && counter < 3) begin
            counter <= counter + 1;
        end else if (counter == 3) begin
            counter <= 0;
        end
        if (counter == 3) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule