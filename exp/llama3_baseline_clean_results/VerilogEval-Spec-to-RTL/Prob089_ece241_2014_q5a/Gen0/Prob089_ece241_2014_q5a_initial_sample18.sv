module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [7:0] acc; // 8 bits, can be increased for larger input
reg [7:0] twos_comp; // 8 bits
reg [2:0] state; // idle, convert, output
reg z_out;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // idle state
        acc <= 0;
        twos_comp <= 0;
        z_out <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (~x) begin
                    state <= 1; // convert state
                    acc <= 1; // start with 1
                end else begin
                    acc <= 0; // stay in idle
                end
            end
            1: begin // convert state
                acc <= {acc[6:0], x}; // accumulate bits
                if (~areset) begin
                    state <= 2; // output state
                    twos_comp <= ~acc + 1; // calculate 2's complement
                end
            end
            2: begin // output state
                z_out <= twos_comp[0]; // output least significant bit of 2's complement
                if (~areset) begin
                    state <= 0; // go back to idle
                    acc <= 0;
                    twos_comp <= 0;
                end
            end
        endcase
    end
end

assign z = z_out;

endmodule