module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] data_reg;               // 4-bit data register
reg [1:0] cnt;                    // 2-bit counter
reg [1:0] state, next_state;     // Current and next state of the FSM
reg         valid_out_reg;       // Registered valid output signal
reg         dout_reg;             // Registered serial output signal

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam OUTPUT = 2'b10;

// FSM state transition logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers and signals
        state <= IDLE;
        data_reg <= 4'b0000;
        cnt <= 2'b00;
        valid_out_reg <= 1'b0;
        dout_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (d!= 4'b0000) begin
                    // Transition to LOAD state if new data is available
                    next_state <= LOAD;
                end else begin
                    next_state <= IDLE;
                end
            end
            LOAD: begin
                // Load parallel data into the data register and reset counter
                data_reg <= d;
                cnt <= 2'b00;
                next_state <= OUTPUT;
            end
            OUTPUT: begin
                // Output serial data bit by bit
                if (cnt == 3) begin
                    // Transition back to IDLE state after all bits have been output
                    next_state <= IDLE;
                end else begin
                    // Increment counter and shift data register for next output
                    cnt <= cnt + 1;
                    next_state <= OUTPUT;
                end
            end
            default: begin
                next_state <= IDLE;
            end
        endcase

        // Update registered signals
        state <= next_state;
        valid_out_reg <= (state == OUTPUT)? 1'b1 : 1'b0;
        dout_reg <= data_reg[3];

        // Shift data register for next output
        if (state == OUTPUT) begin
            data_reg <= {data_reg[2:0], 1'b0};
        end
    end
end

// Assign output signals
assign valid_out = valid_out_reg;
assign dout = dout_reg;

endmodule