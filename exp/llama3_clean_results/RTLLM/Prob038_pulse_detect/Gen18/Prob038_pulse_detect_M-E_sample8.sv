module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] counter; // Counter to track cycles data_in is high
reg prev_data_in; // Register to track previous value of data_in

// Sequential logic to update counter and previous value
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        counter <= 2'b00;
        prev_data_in <= 1'b0;
    end else begin
        if (data_in && !prev_data_in) begin // Rising edge of data_in
            counter <= 1'b1; // Start counting
        end else if (data_in && prev_data_in) begin // data_in is high
            counter <= counter + 1'b1; // Continue counting
        end else begin // data_in is low
            counter <= 2'b00; // Reset counter
        end
        prev_data_in <= data_in;
    end
end

// Combinational logic to generate output
assign data_out = (!data_in && prev_data_in && counter >= 2'b01); // Set data_out to 1 when input transitions from high to low after a pulse

endmodule