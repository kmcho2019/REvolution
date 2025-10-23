module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Metastability protection and input synchronization
reg [1:0] sync_data_in;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) sync_data_in <= 2'b00;
    else sync_data_in <= {sync_data_in[0], data_in};
end

// Debounced input signal
wire debounced_in = sync_data_in[1];

// State encoding
typedef enum logic [1:0] {
    IDLE = 2'b00,
    GOT_0 = 2'b01,
    GOT_01 = 2'b10
} state_t;

state_t curr_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        curr_state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        curr_state <= next_state;
        
        // Registered output
        data_out <= (curr_state == GOT_01) && (debounced_in == 1'b0);
    end
end

// Next state logic
always_comb begin
    next_state = curr_state;
    case (curr_state)
        IDLE:   next_state = debounced_in ? IDLE : GOT_0;
        GOT_0:  next_state = debounced_in ? GOT_01 : GOT_0;
        GOT_01: next_state = debounced_in ? IDLE : GOT_0;
        default: next_state = IDLE;
    endcase
end

endmodule