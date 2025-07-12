module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding (same binary encoding)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic using continuous assignments
    wire next_state_idle = (state == STOP && in) || (state == WAIT && in);
    wire next_state_receive = (state == IDLE && !in) || (state == RECEIVE && bit_count != 3'b111);
    wire next_state_stop = (state == RECEIVE && bit_count == 3'b111);
    wire next_state_wait = (state == STOP && !in);

    wire [1:0] next_state = next_state_idle ? IDLE :
                           next_state_receive ? RECEIVE :
                           next_state_stop ? STOP :
                           next_state_wait ? WAIT :
                           state;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            // Counter and shift register logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
                data_reg <= {in, data_reg[7:1]};  // LSB first
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

    // Done signal generation
    assign done = (state == STOP) && in;

endmodule