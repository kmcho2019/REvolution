module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

// Define the states
localparam IDLE = 2'b00;
localparam SEEN_1 = 2'b01;
localparam SEEN_10 = 2'b10;

// Define the state register
reg [1:0] state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state register on asynchronous reset
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (x) begin
                    state <= SEEN_1;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN_1: begin
                if (!x) begin
                    state <= SEEN_10;
                end else begin
                    state <= SEEN_1;
                end
            end
            SEEN_10: begin
                if (x) begin
                    state <= SEEN_1; // Correctly recognize "101" and reset for next sequence
                end else begin
                    state <= IDLE; // If '0' is seen after "10", reset to IDLE
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// Output logic: Assert z when the sequence "101" is detected
always_comb begin
    if (state == SEEN_10 && x) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule