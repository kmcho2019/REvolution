module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam HIGH      = 2'd1;
    localparam PULSE_END = 2'd2;

    reg [1:0] state, next_state;
    reg       next_data_out;

    // Sequential logic: update state and output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state    <= next_state;
            data_out <= next_data_out;
        end
    end

    // Combinational logic: next state and output calculation
    always @(*) begin
        // Default assignments
        next_state = state;
        next_data_out = 1'b0;

        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state = HIGH;
                    next_data_out = 1'b0;
                end else begin
                    next_state = IDLE;
                    next_data_out = 1'b0;
                end
            end

            HIGH: begin
                if (data_in == 1'b0) begin
                    next_state = PULSE_END;
                    next_data_out = 1'b1; // Output pulse at end
                end else begin
                    next_state = HIGH;
                    next_data_out = 1'b0;
                end
            end

            PULSE_END: begin
                if (data_in == 1'b1) begin
                    next_state = HIGH;
                    next_data_out = 1'b0;
                end else begin
                    next_state = IDLE;
                    next_data_out = 1'b0;
                end
            end

            default: begin
                next_state = IDLE;
                next_data_out = 1'b0;
            end
        endcase
    end

endmodule