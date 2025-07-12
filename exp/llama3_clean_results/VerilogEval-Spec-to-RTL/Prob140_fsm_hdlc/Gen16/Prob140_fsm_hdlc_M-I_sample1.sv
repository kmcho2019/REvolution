module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Use one-hot encoding for states to simplify logic and potentially reduce area
reg [7:0] state; // 8 bits for one-hot encoding
reg disc_reg, flag_reg, err_reg;

// Define the states
localparam IDLE = 8'b00000001;
localparam ONE = 8'b00000010;
localparam TWO = 8'b00000100;
localparam THREE = 8'b00001000;
localparam FOUR = 8'b00010000;
localparam FIVE = 8'b00100000;
localparam SIX = 8'b01000000;
localparam SEVEN = 8'b10000000;

// Use a single always block for state transitions and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        // Simplify next state logic using one-hot encoding
        case (1'b1)
            state[0]: // IDLE
                if (in) state <= ONE;
                else state <= IDLE;
            state[1]: // ONE
                if (in) state <= TWO;
                else state <= IDLE;
            state[2]: // TWO
                if (in) state <= THREE;
                else state <= IDLE;
            state[3]: // THREE
                if (in) state <= FOUR;
                else state <= IDLE;
            state[4]: // FOUR
                if (in) state <= FIVE;
                else state <= IDLE;
            state[5]: // FIVE
                if (in) state <= SIX;
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
            state[6]: // SIX
                if (in) begin
                    state <= SEVEN;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
            state[7]: // SEVEN
                if (~in) state <= IDLE;
                else begin
                    state <= SEVEN;
                    err_reg <= 1;
                end
            default: state <= IDLE;
        endcase
        
        // Reset output registers for next cycle
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end
end

// Directly assign output signals to reduce combinational logic
assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

// Apply clock gating based on state to reduce power consumption
// (This is a placeholder; actual implementation depends on the specific design requirements)

endmodule