module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
localparam IDLE = 2'b00;
localparam SEQ_1 = 2'b01;
localparam SEQ_10 = 2'b10;

// Define the state register
reg [1:0] state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state on asynchronous reset
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (x) begin
                    state <= SEQ_1;
                end
            end
            SEQ_1: begin
                if (!x) begin
                    state <= SEQ_10;
                end else begin
                    state <= SEQ_1; // Stay in the same state if we get another '1'
                end
            end
            SEQ_10: begin
                if (x) begin
                    state <= IDLE; // Reset the state if we get the final '1'
                end else begin
                    state <= SEQ_1; // Go back to waiting for the '0' after the first '1'
                end
            end
        endcase
    end
end

// Output logic: Assert z when we are in the final state and get the final '1'
assign z = (state == SEQ_10) && x;

endmodule