module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding parameters
    parameter IDLE   = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter STOP    = 2'b10;
    parameter ERROR   = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic using continuous assignments
    wire start_detected = (state == IDLE) & ~in;
    wire all_bits_received = (bit_count == 3'b111);
    wire stop_valid = (state == STOP) & in;
    wire stop_invalid = (state == STOP) & ~in;

    wire [1:0] next_state = 
        reset ? IDLE :
        start_detected ? RECEIVE :
        (state == RECEIVE) ? (all_bits_received ? STOP : RECEIVE) :
        (state == STOP) ? (in ? IDLE : ERROR) :
        (state == ERROR) ? (in ? IDLE : ERROR) :
        IDLE;

    // Data register update
    wire data_reg_update = (state == RECEIVE) & ~reset;
    wire [7:0] next_data = {in, data_reg[7:1]};

    // Bit counter update
    wire bit_count_update = (state == RECEIVE) & ~reset;
    wire [2:0] next_bit_count = bit_count + 1;

    // Sequential logic
    always @(posedge clk) begin
        state <= next_state;
        if (reset) begin
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            if (data_reg_update) data_reg <= next_data;
            if (bit_count_update) bit_count <= next_bit_count;
            if (next_state == IDLE) bit_count <= 0;
        end
    end

    // Output logic
    assign done = stop_valid;

endmodule