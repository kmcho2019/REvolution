module TopModule (
    input        cpu_overheated,
    output reg   shut_off_computer,
    input        arrived,
    input        gas_tank_empty,
    output reg   keep_driving
);

    wire shut_off_condition;
    wire keep_driving_condition;

    // Combinational logic separated
    assign shut_off_condition = cpu_overheated;
    assign keep_driving_condition = (~arrived) & (~gas_tank_empty);

    always @(*) begin
        // Defaults to avoid latches
        shut_off_computer = 0;
        keep_driving = 0;

        shut_off_computer = shut_off_condition;
        keep_driving = keep_driving_condition;
    end

endmodule