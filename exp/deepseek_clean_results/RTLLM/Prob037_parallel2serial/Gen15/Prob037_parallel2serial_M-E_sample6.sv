module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] ptr;          // Circular pointer (0-3)
    reg [3:0] data_buf;     // Circular buffer holds parallel data
    reg load_phase;         // Indicates when to load new data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'b0;
            data_buf <= 4'b0;
            load_phase <= 1'b1;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Pointer management
            if (load_phase) begin
                ptr <= 2'b0;            // Reset pointer on load
                data_buf <= d;          // Capture new data
                load_phase <= 1'b0;     // Exit load phase
                valid_out <= 1'b1;      // First bit is valid
            end else begin
                ptr <= ptr + 1'b1;     // Increment pointer
                valid_out <= 1'b0;     // Subsequent bits not valid
                
                if (ptr == 2'b10) begin // Prepare for next load
                    load_phase <= 1'b1; // Enter load phase next cycle
                end
            end

            // Direct bit selection based on pointer
            case (ptr)
                2'b00: dout <= data_buf[3];
                2'b01: dout <= data_buf[2];
                2'b10: dout <= data_buf[1];
                2'b11: dout <= data_buf[0];
            endcase
        end
    end

endmodule