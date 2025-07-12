module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= calculate_next_state(current_state);
    end
end

function [511:0] calculate_next_state;
input [511:0] current_state;
reg [511:0] next_state;
integer i;
begin
    for (i = 0; i < 512; i++) begin
        reg left_neighbor, right_neighbor, center;
        
        // Handle boundaries
        if (i == 0) begin
            left_neighbor = 0;
        end else begin
            left_neighbor = current_state[i - 1];
        end
        
        center = current_state[i];
        
        if (i == 511) begin
            right_neighbor = 0;
        end else begin
            right_neighbor = current_state[i + 1];
        end
        
        // Apply Rule 90 logic
        next_state[i] = left_neighbor ^ right_neighbor;
    end
    
    calculate_next_state = next_state;
end
endfunction

assign q = current_state;

endmodule