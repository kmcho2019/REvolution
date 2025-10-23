module width_8to16 (
    input         clk, // Clock signal
    input         rst_n, // Active-low reset signal
    input         valid_in, // Input signal indicating the validity of the input data
    input  [7:0]  data_in, // 8-bit input data to be converted
    output        valid_out, // Output signal indicating the validity of the output data
    output [15:0] data_out // 16-bit output data resulting from the width conversion
);

// Enum for state machine states
enum logic [1:0] {IDLE, DATA_LOCKED} state, next_state;

// Registers
reg [7:0]  data_lock; // Temporary storage for the first valid data
reg         valid_out_reg; // Registered output validity signal
reg [15:0] data_out_reg; // Registered output data

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_lock <= 8'd0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'd0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_lock <= data_in;
                    next_state <= DATA_LOCKED;
                end else begin
                    next_state <= IDLE;
                end
            end
            DATA_LOCKED: begin
                if (valid_in) begin
                    data_out_reg <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    next_state <= IDLE;
                end else begin
                    next_state <= DATA_LOCKED;
                end
            end
        endcase
        state <= next_state;
    end
end

// Continuous assignments for outputs
assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

// Reset valid_out_reg when output is valid and next clock edge occurs without valid_in
always @(posedge clk) begin
    if (valid_out_reg && !valid_in) begin
        valid_out_reg <= 1'b0;
    end
end

endmodule