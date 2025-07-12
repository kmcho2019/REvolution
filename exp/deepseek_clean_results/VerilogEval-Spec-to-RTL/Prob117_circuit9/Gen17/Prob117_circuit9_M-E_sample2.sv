module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State definitions
localparam HOLD = 1'b0;
localparam COUNT = 1'b1;

reg state;
reg [2:0] counter;

// State transition logic
always @(posedge clk) begin
    case(state)
        HOLD: begin
            if (~a) begin
                state <= COUNT;
                counter <= 3'd0;
            end
        end
        COUNT: begin
            if (a) begin
                state <= HOLD;
            end
            else if (counter == 3'd6) begin
                counter <= 3'd0;
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    endcase
end

// Output generation
always @(*) begin
    q = (state == HOLD) ? 3'd4 : counter;
end

endmodule