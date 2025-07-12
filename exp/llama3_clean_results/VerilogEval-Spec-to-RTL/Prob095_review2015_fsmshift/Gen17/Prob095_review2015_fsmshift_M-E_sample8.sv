module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Flag to indicate reset phase
    logic reset_phase;

    // Counter to track cycles during reset
    logic [1:0] counter;

    // Sequential logic for counter and reset phase
    always_ff @(posedge clk) begin
        if (reset) begin
            reset_phase <= 1'b1;
            counter <= 2'b00; // Reset counter to 0
        end else if (reset_phase) begin
            if (counter == 4'd3) begin // Check if counter has reached 4 cycles
                reset_phase <= 1'b0;
            end else begin
                counter <= counter + 1'b1; // Increment counter
            end
        end else begin
            // Do nothing when not in reset phase
            reset_phase <= 1'b0;
            counter <= 2'b00;
        end
    end

    // Combinational logic for shift_ena
    always_comb begin
        if (reset_phase) begin
            shift_ena = 1'b1; // Assert shift_ena during reset phase
        end else begin
            shift_ena = 1'b0;
        end
    end

endmodule