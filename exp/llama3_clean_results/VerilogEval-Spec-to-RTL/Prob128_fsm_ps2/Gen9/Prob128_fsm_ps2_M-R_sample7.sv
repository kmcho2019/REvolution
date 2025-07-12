module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] counter;
logic [7:0] buffer [2:0];

assign done = (counter == 2'd2);

always_ff @(posedge clk) begin
    if(reset) begin
        counter <= 0;
        buffer[0] <= 0;
        buffer[1] <= 0;
        buffer[2] <= 0;
    end else begin
        if (in[3] && counter == 2'd0) begin
            counter <= 1;
            buffer[0] <= in;
        end else if (counter == 2'd1) begin
            counter <= 2;
            buffer[1] <= in;
        end else if (counter == 2'd2) begin
            counter <= 0;
            buffer[2] <= in;
        end
    end
end

endmodule