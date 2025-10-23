module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    localparam WAIT   = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state logic using continuous assignments
    wire next_idle   = (state == IDLE   && !in) || 
                      (state == STOP   && in)  || 
                      (state == WAIT   && in);
    wire next_receive = (state == IDLE   && !in) || 
                       (state == RECEIVE && bit_count != 3'd7);
    wire next_stop    = (state == RECEIVE && bit_count == 3'd7);
    wire next_wait    = (state == STOP   && !in);

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= {4{next_wait}}   & WAIT   |
                    {4{next_stop}}    & STOP   |
                    {4{next_receive}} & RECEIVE |
                    {4{next_idle}}    & IDLE;

            if (state == IDLE) begin
                bit_count <= 0;
            end else if (state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1;
            end
        end
    end

    // Done signal is high when in STOP state and input is 1
    assign done = (state == STOP) && in;

endmodule