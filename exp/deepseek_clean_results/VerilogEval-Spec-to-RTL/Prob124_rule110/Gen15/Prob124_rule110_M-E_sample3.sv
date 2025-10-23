module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Memory to store current and next states
    reg [511:0] current_state, next_state;
    
    // Shift register for processing window
    reg [2:0] window;  // Stores left, center, right
    
    // Control signals
    reg [8:0] counter;  // 512 cells need 9 bits
    wire processing_done = (counter == 9'd511);
    
    // Rule 110 logic function
    function rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            counter <= 9'd0;
        end else begin
            if (!processing_done) begin
                // Load window (handle boundaries)
                window[2] <= (counter == 9'd0) ? 1'b0 : current_state[counter-1];  // left
                window[1] <= current_state[counter];                                // center
                window[0] <= (counter == 9'd511) ? 1'b0 : current_state[counter+1]; // right
                
                // Compute next state
                next_state[counter] <= rule110(window[2], window[1], window[0]);
                
                counter <= counter + 1;
            end else begin
                // Update all states at once when done
                current_state <= next_state;
                counter <= 9'd0;
            end
        end
    end

    assign q = current_state;

endmodule