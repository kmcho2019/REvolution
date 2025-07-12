module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] history;  // Stores last 3 samples
reg prev_data;      // Stores previous input for change detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 3'b000;
        prev_data <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        prev_data <= data_in;
        
        // Only update history if input changed
        if (data_in != prev_data) begin
            history <= {history[1:0], data_in};
            
            // Only update output when history changes
            data_out <= (history == 3'b010);
        end
        else begin
            data_out <= 1'b0;
        end
    end
end

endmodule