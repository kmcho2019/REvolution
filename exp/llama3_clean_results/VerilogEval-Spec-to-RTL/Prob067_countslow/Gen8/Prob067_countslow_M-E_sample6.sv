module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] counter;
reg [1:0] state; // 0: idle, 1: counting

always @(posedge clk) begin
    case (state)
        2'b00: begin // idle
            if (reset) begin
                counter <= 4'b0000;
                state <= 2'b00;
            end else if (slowena) begin
                state <= 2'b01;
            end
        end
        2'b01: begin // counting
            if (reset) begin
                counter <= 4'b0000;
                state <= 2'b00;
            end else begin
                counter <= counter + 1;
                if (counter == 4'b1001) begin
                    counter <= 4'b0000;
                end
                if (!slowena) begin
                    state <= 2'b00;
                end
            end
        end
        default: begin
            state <= 2'b00;
        end
    endcase
end

assign q = counter;

endmodule