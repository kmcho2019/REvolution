// Define the states as enumerations
`define OFF 2'b00
`define ON  2'b01

module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg [1:0] state; // current state
reg [1:0] next_state; // next state

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= `OFF;
    end else begin
        state <= next_state;
    end
end

// Synchronous logic to determine the next state
always @(*) begin
    case (state)
        `OFF: begin
            if (j == 1'b1) begin
                next_state = `ON;
            end else begin
                next_state = `OFF;
            end
        end
        `ON: begin
            if (k == 1'b1) begin
                next_state = `OFF;
            end else begin
                next_state = `ON;
            end
        end
        default: next_state = `OFF; // Default to OFF if state is unknown
    endcase
end

// Output logic
always @(*) begin
    case (state)
        `OFF: out = 1'b0;
        `ON:  out = 1'b1;
        default: out = 1'b0; // Default output to 0 if state is unknown
    endcase
end

endmodule