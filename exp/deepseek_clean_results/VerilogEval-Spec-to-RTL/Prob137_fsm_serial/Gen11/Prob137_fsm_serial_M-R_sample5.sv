module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State definitions
    localparam [1:0] IDLE   = 2'b00;
    localparam [1:0] RECEIVE = 2'b01;
    localparam [1:0] STOP   = 2'b10;
    localparam [1:0] ERROR  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic (combinational)
    wire [1:0] next_state;
    assign next_state = 
        (state == IDLE)    ? (~in ? RECEIVE : IDLE) :
        (state == RECEIVE) ? (bit_count == 3'b111 ? STOP : RECEIVE) :
        (state == STOP)    ? (in ? IDLE : ERROR) :
        (state == ERROR)   ? (in ? IDLE : ERROR) :
        IDLE;

    // Data register update (combinational)
    wire [7:0] next_data;
    assign next_data = 
        (state == RECEIVE) ? {in, data_reg[7:1]} : data_reg;

    // Bit counter update (combinational)
    wire [2:0] next_bit_count;
    assign next_bit_count = 
        (state == IDLE)    ? 3'b000 :
        (state == RECEIVE)  ? bit_count + 1 :
        bit_count;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            data_reg <= next_data;
        end
    end

    // Output logic (combinational)
    assign done = (state == STOP) && in;

endmodule