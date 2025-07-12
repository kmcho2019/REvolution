module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg [2:0] ones; // counter for consecutive 1s

localparam IDLE = 3'b000;
localparam ONES = 3'b001;
localparam FLAG = 3'b010;
localparam ERROR = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ones <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES;
                    ones <= 1;
                end
            end
            ONES: begin
                if (in) begin
                    ones <= ones + 1;
                    if (ones == 6) state <= FLAG;
                end else begin
                    if (ones == 5) state <= IDLE;
                    else begin
                        state <= IDLE;
                        ones <= 0;
                    end
                end
            end
            FLAG: begin
                if (~in) begin
                    state <= IDLE;
                end else begin
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (~in) state <= IDLE;
            end
        endcase
    end
end

assign disc = (state == IDLE && ones == 5);
assign flag = (state == IDLE && ones == 6 && in == 0);
assign err = (state == ERROR);

endmodule