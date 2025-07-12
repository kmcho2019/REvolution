module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_FIRST,
    OUTPUT
} state_t;

reg [1:0] state, next_state;
reg [7:0] data_lock;
reg [15:0] next_data_out;
reg next_valid_out;

// State transition and output logic
always @(*) begin
    next_state = state;
    next_data_out = data_out;
    next_valid_out = 1'b0;
    
    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = GOT_FIRST;
                next_data_out = {data_in, 8'b0}; // MSB captured
            end
        end
        
        GOT_FIRST: begin
            if (valid_in) begin
                next_state = OUTPUT;
                next_data_out = {data_out[15:8], data_in}; // Complete 16-bit
                next_valid_out = 1'b1;
            end
        end
        
        OUTPUT: begin
            next_state = IDLE;
            if (valid_in) begin
                next_state = GOT_FIRST;
                next_data_out = {data_in, 8'b0};
            end
        end
        
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        state <= next_state;
        data_out <= next_data_out;
        valid_out <= next_valid_out;
    end
end

endmodule