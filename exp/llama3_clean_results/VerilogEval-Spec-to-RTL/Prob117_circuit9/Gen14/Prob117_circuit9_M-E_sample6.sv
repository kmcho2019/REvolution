module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;
reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'b00: begin // RESET
            if (a) begin
                counter <= 4;
                state <= 2'b00;
            end else begin
                state <= 2'b01;
            end
        end
        2'b01: begin // INCREMENT
            if (!a) begin
                if (counter < 6) begin
                    counter <= counter + 1;
                    state <= 2'b01;
                end else begin
                    counter <= 0;
                    state <= 2'b01;
                end
            end else begin
                state <= 2'b00;
            end
        end
        default: state <= 2'b00;
    endcase
end

assign q = counter;

initial begin
    state = 2'b00;
    counter = 4;
end

endmodule