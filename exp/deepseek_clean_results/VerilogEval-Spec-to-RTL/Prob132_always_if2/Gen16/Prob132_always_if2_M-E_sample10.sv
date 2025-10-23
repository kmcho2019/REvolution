module TopModule (
    input      clk,            // Added clock for state machine
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // State definitions
    localparam NORMAL = 1'b0;
    localparam EMERGENCY = 1'b1;
    
    reg state;

    always @(posedge clk) begin
        // State transition logic
        if (cpu_overheated)
            state <= EMERGENCY;
        else
            state <= NORMAL;
        
        // Output logic
        case (state)
            NORMAL: begin
                shut_off_computer <= 1'b0;
                keep_driving <= ~arrived & ~gas_tank_empty;
            end
            EMERGENCY: begin
                shut_off_computer <= 1'b1;
                keep_driving <= 1'b0;  // Stop driving in emergency
            end
        endcase
    end

endmodule