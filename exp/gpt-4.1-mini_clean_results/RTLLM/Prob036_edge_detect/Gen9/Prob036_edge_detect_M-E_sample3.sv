module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg [1:0] a_shift;       // Stores previous two samples of 'a'
    reg rise_flag;           // Indicates a detected rising edge not yet cleared
    reg down_flag;           // Indicates a detected falling edge not yet cleared

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_shift   <= 2'b00;
            rise_flag <= 1'b0;
            down_flag <= 1'b0;
            rise      <= 1'b0;
            down      <= 1'b0;
        end else begin
            // Shift in new sample
            a_shift <= {a_shift[0], a};

            // Edge detection on shifted samples
            // Rising edge detected when a_shift changes from 0 to 1: 2'b01
            if (a_shift == 2'b01)
                rise_flag <= 1'b1;
            // Falling edge detected when a_shift changes from 1 to 0: 2'b10
            else if (a_shift == 2'b10)
                down_flag <= 1'b1;

            // Output logic: hold 'rise' and 'down' high once set
            // Clear rise when a rising edge appears again (implied by setting rise_flag)
            // Similarly for down
            if (rise_flag)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            if (down_flag)
                down <= 1'b1;
            else
                down <= 1'b0;

            // Clear flags when corresponding edges appear again to make outputs pulse only once per edge
            if (a_shift == 2'b01 && rise_flag)
                rise_flag <= 1'b0;  // Clear after asserting rise
            if (a_shift == 2'b10 && down_flag)
                down_flag <= 1'b0;  // Clear after asserting down
        end
    end

endmodule