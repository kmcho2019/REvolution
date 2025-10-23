module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Define priority states
    localparam [1:0] 
        NORMAL = 2'b00,
        OVERHEAT = 2'b01,
        DRIVING = 2'b10;

    reg [1:0] state;

    always @(*) begin
        // Priority encoding - overheating takes highest priority
        if (cpu_overheated) begin
            state = OVERHEAT;
        end
        else if (~arrived) begin
            state = DRIVING;
        end
        else begin
            state = NORMAL;
        end

        // Default outputs
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;

        // State-dependent outputs
        case (state)
            OVERHEAT: begin
                shut_off_computer = 1'b1;
            end
            DRIVING: begin
                keep_driving = ~gas_tank_empty;
            end
            NORMAL: begin
                // Default outputs already set
            end
        endcase
    end

endmodule