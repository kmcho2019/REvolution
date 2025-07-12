module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Reduced number of states
reg [2:0] count; // Counter for consecutive '1's

localparam IDLE = 3'b000;
localparam ONES = 3'b001;
localparam FIVE_ONES = 3'b010;
localparam SIX_ONES = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        disc <= 0;
        flag <= 0;
        err <= 0;

        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES;
                    count <= 1;
                end
            end
            ONES: begin
                if (in) begin
                    count <= count + 1;
                    if (count == 5) state <= FIVE_ONES;
                end else state <= IDLE;
            end
            FIVE_ONES: begin
                if (in) begin
                    state <= SIX_ONES;
                    disc <= 1;
                end else state <= IDLE;
            end
            SIX_ONES: begin
                if (in) begin
                    err <= 1;
                end else begin
                    flag <= 1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule