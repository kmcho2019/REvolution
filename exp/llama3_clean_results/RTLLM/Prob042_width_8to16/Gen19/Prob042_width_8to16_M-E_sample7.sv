module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

// Define the states for the finite state machine
enum logic [1:0] {Idle, Data_Capture} state, next_state;

// Registers to store the first and second valid 8-bit data inputs
reg [7:0] data_first;
reg [7:0] data_second;

// Register to store the validity of the output data
reg valid_out_reg;

// Output data register
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers on active-low reset
        state <= Idle;
        data_first <= 8'd0;
        data_second <= 8'd0;
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'd0;
    end
    else begin
        // Update logic for the finite state machine
        case (state)
            Idle: begin
                if (valid_in) begin
                    // Capture the first valid 8-bit data input
                    data_first <= data_in;
                    state <= Data_Capture;
                end
                else begin
                    // Remain in the Idle state if no valid input data
                    state <= Idle;
                end
            end
            Data_Capture: begin
                if (valid_in) begin
                    // Capture the second valid 8-bit data input
                    data_second <= data_in;
                    // Concatenate the first and second valid data inputs
                    data_out_reg <= {data_first, data_second};
                    // Assert the valid_out signal
                    valid_out_reg <= 1'b1;
                    state <= Idle;
                end
                else begin
                    // Remain in the Data_Capture state if no valid input data
                    state <= Data_Capture;
                end
            end
            default: begin
                // Default case to handle any unexpected state transitions
                state <= Idle;
            end
        endcase
        
        // Reset the valid_out signal after one clock cycle
        if (valid_out_reg) begin
            valid_out_reg <= 1'b0;
        end
    end
end

// Output assignments
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule