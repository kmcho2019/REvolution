// Frequency divider module using a state machine
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor, must be greater than 0
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate if NUM_DIV is an even number
generate
    if (NUM_DIV <= 0 || (NUM_DIV % 2) != 0) begin
        $error("NUM_DIV must be an even number greater than 0");
    end
endgenerate

// Enumerated type for state machine states
enum logic [1:0] {
    S_IDLE,
    S_COUNT
} state, next_state;

// Calculate the number of states needed for the state machine
localparam NUM_STATES = NUM_DIV / 2;

reg [1:0] state_cnt;  // State counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= S_IDLE;
        state_cnt <= 0;
        clk_div <= 0;
    end else begin
        case (state)
            S_IDLE: begin
                state_cnt <= 0;
                state <= S_COUNT;
            end
            S_COUNT: begin
                if (state_cnt == (NUM_STATES - 1)) begin
                    state_cnt <= 0;
                    state <= S_IDLE;
                    clk_div <= ~clk_div;
                end else begin
                    state_cnt <= state_cnt + 1;
                end
            end
        endcase
    end
end

endmodule

// Example testbench to instantiate the freq_diveven module
module freq_diveven_tb;
    reg clk;
    reg rst_n;
    wire clk_div;

    freq_diveven #(.NUM_DIV(4)) u_freq_diveven (
       .clk(clk),
       .rst_n(rst_n),
       .clk_div(clk_div)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        #100;
        $finish;
    end
endmodule