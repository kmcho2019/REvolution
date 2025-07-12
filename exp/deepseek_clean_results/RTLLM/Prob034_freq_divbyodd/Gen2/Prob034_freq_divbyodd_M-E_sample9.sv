module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    reg [31:0] state;
    wire toggle_posedge;
    wire toggle_negedge;
    
    // Calculate toggle points
    localparam FIRST_TOGGLE = (NUM_DIV - 1) / 2;
    localparam SECOND_TOGGLE = NUM_DIV - 1;
    
    // Edge detection signals
    assign toggle_posedge = (state == FIRST_TOGGLE);
    assign toggle_negedge = (state == SECOND_TOGGLE);
    
    // State machine and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 0;
            clk_div <= 0;
        end else begin
            if (state == SECOND_TOGGLE) begin
                state <= 0;
            end else begin
                state <= state + 1;
            end
            
            if (toggle_posedge) begin
                clk_div <= ~clk_div;
            end
        end
    end
    
    // Negative edge processing
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset handled in posedge block
        end else if (toggle_negedge) begin
            clk_div <= ~clk_div;
        end
    end

endmodule